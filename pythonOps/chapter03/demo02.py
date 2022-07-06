import os
import sys


def main():
    sys.argv.append("")
    filename = sys.argv[1] # 空字符串防止不写参数，导致索引越界
    if not os.path.isfile(filename):
        raise SystemExit(filename + ' does not exists')
    elif not os.access(filename, os.R_OK):
        raise SystemExit(filename + ' is not accessible')
    else:
        print(filename + ' is accessible')


if __name__ == '__main__':
    main()
