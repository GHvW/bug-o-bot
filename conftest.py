import os
import importlib

import py
import pytest
import hy
# from hy._compat import PY36, PY38
# HY_TESTS = os.path.join("", "tests", "native_tests", "")
HY_TESTS = os.path.join("", "tests", "")

def pytest_collect_file(parent, path):
    if (path.ext == ".hy"
        and HY_TESTS in path.dirname + os.sep
        and path.basename != "__init__.hy"):
        if hasattr(pytest.Module, "from_parent"):
            pytest_mod = pytest.Module.from_parent(parent, fspath=path)
        else:
            pytest_mod = pytest.Module(path, parent)
        return pytest_mod