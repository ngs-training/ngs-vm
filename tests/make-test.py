#!/usr/bin/env python3

import os,sys,json,re

def usage():
    print('Usage: make-test.py [OPTIONS] index.ipynb')
    print('Options:')
    print('   -o, --output FILE     Output file')
    sys.exit(1)

def parse_opts():
    opts = {}
    opts['files'] = []
    args = sys.argv[1:]
    while len(args):
        if args[0]=='-o' or args[0]=='--output':
            args = args[1:]
            opts['outfile'] = args[0]
        elif os.path.isfile(args[0]):
            opts['files'].append(args[0])
        else:
            usage()
        args = args[1:]
    if len(opts['files']) == 0: usage()
    if 'outfile' in opts: opts['fh'] = open(opts['outfile'],"w")
    else: opts['fh'] = sys.stdout
    return opts

def process_file(opts,file):
    nb = json.load(open(file))
    opts['fh'].write("\n# "+file+"\n")
    next_file = None
    for cell in nb['cells']:
        if cell['cell_type'] == 'markdown':
            for line in cell['source']:
                m = re.search(r'\(([^(]+\.ipynb)\)',line); 
                if m!=None: next_file = m.group(1)
        if cell['cell_type'] == 'code':
            for line in cell['source']:
                line = line.rstrip('\n')
                if line[-1]=='\\':
                    line = line.rstrip('\\')
                    opts['fh'].write(line)
                else:
                    opts['fh'].write(line)
                    opts['fh'].write("\n")
    opts['fh'].write("\n")
    if next_file!=None:
        dir = '.'
        m = re.search(r'^(.*)/[^/]+$',file);
        if m!=None and m.group(1)!='': dir = m.group(1)
        opts['files'].append(dir+'/'+next_file)

def main(opts):
    opts['fh'].write("#!/bin/bash\n")
    opts['fh'].write("set -e\n")
    opts['fh'].write("set -x\n")
    opts['fh'].write("set -o pipefail\n")

    for file in opts['files']:
        process_file(opts,file)

    opts['fh'].close()

if __name__ == "__main__":
    opts = parse_opts()
    main(opts)

