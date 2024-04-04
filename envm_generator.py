import os
import sys


def check_path(target):
    if (os.path.exists(target)):
        return target
    else:
        return None

if __name__ == "__main__":
    opt_path = sys.argv[1]
    out = []
    if bin_path := check_path(os.path.join(opt_path, "bin")):
        out.append(f"prepend-path PATH {bin_path}")
    if sbin_path := check_path(os.path.join(opt_path, "sbin")):
        out.append(f"prepend-path PATH {sbin_path}")
    if lib_path := check_path(os.path.join(opt_path, "lib")):
        out.append(f"prepend-path LIBRARY_PATH {lib_path}")
        out.append(f"prepend-path LD_LIBRARY_PATH {lib_path}")
    if lib64_path := check_path(os.path.join(opt_path, "lib64")):
        out.append(f"prepend-path LIBRARY_PATH {lib64_path}")
        out.append(f"prepend-path LD_LIBRARY_PATH {lib64_path}")
    if inc_path := check_path(os.path.join(opt_path, "include")):
        out.append(f"prepend-path CPATH {inc_path}")

    print("#%Module\n")
    print("\n".join(out))
