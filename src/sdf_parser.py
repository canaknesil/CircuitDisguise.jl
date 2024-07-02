# MIT License

# Copyright (c) 2024 Can Aknesil

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# This file contains a superficial parser for Standard Delay Format
# (SDF) files to be used in the Circuit Disguise project. Tokens other
# than the parentheses and some keywords are categorized as either
# string, or text.

# The parser parses only the SDF syntax necessary for the Circuit
# Disguise Project, only upto required depth of detail. But,
# unsupported part of the SDF syntax is allowed to appear in the
# input, which is parsed as a generic s-expression.


import ply.lex as lex
import ply.yacc as yacc
import json


#
# Lexical Analyzer
#

reserved = {
    'DELAYFILE': 'DELAYFILE',
    'DESIGN': 'DESIGN',
    'DIVIDER': 'DIVIDER',
    'TIMESCALE': 'TIMESCALE',
    'CELL': 'CELL',
    'INSTANCE': 'INSTANCE',
    'CELLTYPE': 'CELLTYPE',
    'DELAY': 'DELAY',
    'ABSOLUTE': 'ABSOLUTE',
    'INTERCONNECT': 'INTERCONNECT',
    'IOPATH': 'IOPATH',
    'RETAIN': 'RETAIN',
    'TIMINGCHECK': 'TIMINGCHECK',
    'SETUPHOLD': 'SETUPHOLD',
    'SETUP': 'SETUP',
    'HOLD': 'HOLD',
    'RECOVERY': 'RECOVERY',
    'REMOVAL': 'REMOVAL',
    'RECREM': 'RECREM',
    'SKEW': 'SKEW',
    'BIDIRECTSKEW': 'BIDIRECTSKEW',
    'WIDTH': 'WIDTH',
    'PERIOD': 'PERIOD',
    'NOCHANGE': 'NOCHANGE',
    'COND': 'COND',
}

tokens = [
    'QSTRING',
    'LPAREN',
    'RPAREN',
    'TEXT',
] + list(reserved.values())

t_LPAREN = r'\('
t_RPAREN = r'\)'

def t_QSTRING(t):
    r'"([^"]|\\")*"'
    return t

def t_TEXT(t):
    r'([^"\(\)\s]|(\\")|(\\\()|(\\\)))+'
    t.type = reserved.get(t.value, 'TEXT')
    return t


# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

def tokenize(data):
    lexer.input(data)
    tokens = []
    while True:
        tok = lexer.token()
        if not tok:
            break
        tokens.append(tok)
    return tokens


#
# Parser
#

start = 'exp_list'

def p_exp_list(p):
    '''exp_list : 
                | exp_list exp'''
    if len(p) == 1:
        p[0] = []
    elif len(p) == 3:
        p[0] = p[1] + [p[2]]

def p_exp(p):
    '''exp : keyword_exp
           | s_exp
           | qstring
           | text'''
    p[0] = p[1]

def p_keyword_exp(p):
    '''keyword_exp : LPAREN DELAYFILE    exp_list RPAREN
                   | LPAREN DESIGN       qstring  RPAREN
                   | LPAREN DIVIDER      TEXT     RPAREN
                   | LPAREN CELL         exp_list RPAREN
                   | LPAREN CELLTYPE     qstring  RPAREN
                   | LPAREN DELAY        exp_list RPAREN
                   | LPAREN ABSOLUTE     exp_list RPAREN
                   | LPAREN TIMINGCHECK  exp_list RPAREN'''
    p[0] = {'type': p[2], 'value': p[3]}

def p_keyword_exp_interconnect(p):
    '''keyword_exp : LPAREN INTERCONNECT port_instance port_instance delval_list RPAREN'''
    p[0] = {'type': 'INTERCONNECT', 'value': {'src_port': p[3], 'dst_port': p[4], 'delval_list': p[5]}}

def p_keyword_exp_instance(p):
    '''keyword_exp : LPAREN INSTANCE TEXT RPAREN
                   | LPAREN INSTANCE RPAREN'''
    if len(p) == 5:
        p[0] = {'type': p[2], 'value': p[3]}
    if len(p) == 4:
        p[0] = {'type': p[2], 'value': ''}

def p_keyword_exp_timescale(p):
    '''keyword_exp : LPAREN TIMESCALE text_list RPAREN'''
    p[0] = {'type': 'TIMESCALE', 'value': "".join(p[3])}

def p_keyword_exp_io_path(p):
    '''keyword_exp : LPAREN IOPATH port_spec port_instance retain_def_list delval_list RPAREN'''
    p[0] = {'type': 'IOPATH', 'value': {'src_port': p[3], 'dst_port': p[4], 'retain_def_list': p[5], 'delval_list': p[6]}}

def p_keyword_exp_setuphold(p):
    '''keyword_exp : LPAREN SETUPHOLD port_tchk port_tchk value value cond_exp_list RPAREN'''
    p[0] = {'type': 'SETUPHOLD', 'value': {'data_port': p[3], 'clk_port': p[4], 'setup': p[5], 'hold': p[6], 'scond_ccond': p[7]}}

def p_keyword_exp_recrem(p):
    '''keyword_exp : LPAREN RECREM port_tchk port_tchk value value cond_exp_list RPAREN'''
    p[0] = {'type': p[2], 'value': {'async_port': p[3], 'clk_port': p[4], 'recovery': p[5], 'removal': p[6], 'scond_ccond': p[7]}}

def p_keyword_exp_setup_and_similar(p):
    '''keyword_exp : LPAREN SETUP port_tchk port_tchk value RPAREN
                   | LPAREN HOLD  port_tchk port_tchk value RPAREN'''
    p[0] = {'type': p[2], 'value': {'data_port': p[3], 'clk_port': p[4], 'val': p[5]}}

def p_keyword_exp_recovery_and_similar(p):
    '''keyword_exp : LPAREN RECOVERY port_tchk port_tchk value RPAREN
                   | LPAREN REMOVAL  port_tchk port_tchk value RPAREN'''
    p[0] = {'type': p[2], 'value': {'async_port': p[3], 'clk_port': p[4], 'val': p[5]}}

def p_keyword_exp_skew(p):
    '''keyword_exp : LPAREN SKEW port_tchk port_tchk value RPAREN'''
    p[0] = {'type': p[2], 'value': {'port1': p[3], 'port2': p[4], 'val': p[5]}}

def p_keyword_exp_bidirectskew_and_similar(p):
    '''keyword_exp : LPAREN BIDIRECTSKEW port_tchk port_tchk value value RPAREN
                   | LPAREN NOCHANGE     port_tchk port_tchk value value RPAREN'''
    p[0] = {'type': p[2], 'value': {'port1': p[3], 'port2': p[4], 'val1': p[5], 'val2': p[6]}}

def p_keyword_exp_width_and_similar(p):
    '''keyword_exp : LPAREN WIDTH  port_tchk value RPAREN
                   | LPAREN PERIOD port_tchk value RPAREN'''
    p[0] = {'type': p[2], 'value': {'port': p[3], 'val': p[4]}}
    
def p_keyword_exp_cond(p):
    '''keyword_exp : cond_exp'''
    p[0] = p[1]

def p_retain_def_list(p):
    '''retain_def_list :
                       | retain_def_list retain_def'''
    if len(p) == 1:
        p[0] = []
    elif len(p) == 3:
        p[0] = p[1] + [p[2]]

def p_retain_def(p):
    '''retain_def : LPAREN RETAIN retval_list RPAREN'''
    p[0] = p[3]

def p_retval_list(p):
    '''retval_list : delval_list'''
    p[0] = p[1]

def p_delval_list(p):
    '''delval_list : delval
                   | delval_list delval'''
    if len(p) == 2:
        p[0] = [p[1]]
    elif len(p) == 3:
        p[0] = p[1] + [p[2]]

def p_delval(p):
    '''delval : value
              | LPAREN value value RPAREN
              | LPAREN value value value RPAREN'''
    if len(p) == 2:
        p[0] = p[1]
    elif len(p) == 5:
        p[0] = [p[2], p[3]]
    elif len(p) == 6:
        p[0] = [p[2], p[3], p[4]]
        
def p_port_tchk(p):
    '''port_tchk : port_spec
                 | cond_exp'''
    p[0] = {'type': 'port_tchk', 'value': p[1]}

def p_port_instance(p):
    '''port_instance : TEXT'''
    p[0] = p[1]
    
def p_port_spec(p):
    '''port_spec : TEXT'''
    p[0] = {'type': 'port_spec', 'value': {'edge': None, 'port': p[1]}}

def p_port_spec_with_edge(p):
    '''port_spec : port_edge'''
    p[0] = {'type': 'port_spec', 'value': p[1]}

def p_port_edge(p):
    '''port_edge : LPAREN TEXT TEXT RPAREN'''
    p[0] = {'edge': p[2], 'port': p[3]}

def p_cond_exp(p):
    '''cond_exp : LPAREN COND exp_list RPAREN'''
    p[0] = {'type': 'COND', 'value': p[3]}

def p_cond_exp_list(p):
    '''cond_exp_list : 
                 | cond_exp_list cond_exp'''
    if len(p) == 1:
        p[0] = []
    elif len(p) == 3:
        p[0] = p[1] + [p[2]]

def p_value(p):
    '''value : LPAREN text_list RPAREN'''
    p[0] = "".join(p[2])
    
def p_s_exp(p):
    '''s_exp : LPAREN exp_list RPAREN'''
    p[0] = {'type': 's_exp', 'value': p[2]}
        
def p_qstring(p):
    '''qstring : QSTRING'''
    p[0] = p[1][1:-1]
    #p[0] = {'type': 'qstring', 'value': p[1][1:-1]}

def p_text(p):
    '''text : TEXT'''
    p[0] = {'type': 'text', 'value': p[1]}

def p_text_list(p):
    '''text_list : 
                 | text_list TEXT'''
    if len(p) == 1:
        p[0] = []
    elif len(p) == 3:
        p[0] = p[1] + [p[2]]


# Error rule for syntax errors
def p_error(p):
    print("Syntax error in input!")


# parsetab.py is automatically generated (updated) if neccessary
# when the parser is built.

# Build the parser
parser = yacc.yacc()


#
# Interface
#

def parse_sdf_file(fname):
    '''Parse an SDF file. Return JSON string.'''
    with open(fname) as f:
        data = f.read()

    #tokens = tokenize(data) # Tokenize only
    ast = yacc.parse(data) # Tokenize and parse

    ast_json_str = json.dumps(ast)
    return ast_json_str



