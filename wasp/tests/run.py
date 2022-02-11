#!/usr/bin/env python3
import os
import sys
import csv
import json
import glob
import time
import subprocess


def execute(test, output):
    try:
        start = time.time()
        result = subprocess.run(
            [
                './wasp',
                test,
                '-m',
                str(-1),
                '-r',
                output
            ],
            check=True,
            capture_output=True
        ) 
        code = result.returncode
    except subprocess.CalledProcessError as e:
        code = e.returncode
    finally:
        delta = time.time() - start
    return code, delta

def basic():
    error_names = []

    print("Running failingING tests.....")
    # failinging tests
    for file in sorted(filter(lambda f : f.endswith('.wast'), \
            os.listdir('tests/failing'))):
        print('Running tests/failing/' + file, end='... ')
        sys.stdout.flush()
        try:
            out = subprocess.check_output(['./wasp', 'tests/failing/' + file], \
                    stderr=subprocess.STDOUT)
            report = json.loads(out)
            if not report['specification']:
                print('OK')
            else:
                print('NOK')
                error_names.append('tests/failing/' + file)
        except subprocess.CalledProcessError as e:
            print('NOK')
            error_names.append('tests/failing/' + file)

    print("\nRunning passingING tests.....")
    # failinging tests
    for file in sorted(filter(lambda f : f.endswith('.wast'), \
            os.listdir('tests/passing'))):
        print('Running tests/passing/' + file, end='... ')
        sys.stdout.flush()
        try:
            out = subprocess.check_output(['./wasp', 'tests/passing/' + file], \
                    stderr=subprocess.STDOUT)
            report = json.loads(out)
            if report['specification']:
                print('OK')
            else:
                print('NOK')
                error_names.append("tests/passing/" + file)
        except subprocess.CalledProcessError as e:
            print('NOK')
            error_names.append("tests/passing/" + file)

    print("Tests that are not behaving correctly: " + \
            str(error_names) + ".\n")

def progress(msg, i, t, prev=0):
    curr_int = round((i / t) * 100)
    prog_str = f'[{curr_int:3}%] {msg}'
    sys.stdout.write('\r')
    sys.stdout.write(' ' * prev)
    sys.stdout.write('\r')
    sys.stdout.write(prog_str)
    sys.stdout.flush()
    return 7 + len(msg)

def btree():
    output = 'output2'
    btree_dir = 'tests/btree2'
    print(f'Running tests in \'{btree_dir}\'...')

    tests = glob.glob(os.path.join(btree_dir, '*.wast'))
    total, prev, tbl = len(tests), 0, []
    for i, t in enumerate(sorted(tests)):
        prev = progress(f'Running \'{t}\'...', i + 1, total, prev=prev)

        output_dir = os.path.join(output, os.path.basename(t))
        _, runtime = execute(t, output_dir)

        report_path = os.path.join(output_dir, 'report.json')
        with open(report_path, 'r') as f:
            report = json.load(f)

        tbl.append([
            os.path.basename(t),
            runtime,
            report['loop_time'],
            report['solver_time'],
            report['paths_explored']
        ])

    results_path = os.path.join(output, 'results.csv')
    with open(results_path, 'w') as f:
        csvwriter = csv.writer(f)
        csvwriter.writerow([
            'Test',
            'T_WASP',
            'T_Loop',
            'T_Solver',
            'N_Paths'
        ])
        csvwriter.writerows(tbl)

    print(f'\nAll Done!')

def main(argv=None):
    # execute basic pass/fail tests
    #basic()
    # execute btree tests
    btree()
    return 0

if __name__ == '__main__':
    sys.exit(main())
