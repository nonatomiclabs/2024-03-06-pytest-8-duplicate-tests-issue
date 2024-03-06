### Context

Pytest 8.0.0 came with a big refactoring of the test collection step. This repo is a
minimal example to highlight and reproduce an issue with the new way the collection
works.

### The issue

The issue shows itself with handling of duplicate paths. For instance, this repo
contains the following test structure:

```plain
> tree tests
tests
├── subdirectory
│   └── test_two.py
└── test_one.py
```

With Pytest 7, if I called `pytest test_one.py tests --collect-only`, it would return 3
tests:

```plain
============================= test session starts ==============================
platform linux -- Python 3.12.2, pytest-7.0.0, pluggy-1.4.0
rootdir: /home
collected 3 items

<Module tests/test_one.py>
  <Function test_one>
<Module tests/test_one.py>
  <Function test_one>
<Module tests/subdirectory/test_two.py>
  <Function test_two>
```

With Pytest 8, we get only one:

```plain
============================= test session starts ==============================
platform linux -- Python 3.12.2, pytest-8.0.2, pluggy-1.4.0
rootdir: /home
collected 1 item

<Dir home>
  <Dir tests>
    <Module test_one.py>
      <Function test_one>
```

To me, neither behavior looks correct:

- in Pytest 7, I would expect `tests/test_one.py` to be correctly identified as a
  duplicate and not to be present (unless the `--keep-duplicates` option was specified
  of course)
- in Pytest 8, I would expect `tests/test_one.py` not to block the collection of
  `tests/subdirectory/test_two.py`, despite `tests/test_one.py` being a duplicate

### How to reproduce?

This repo provides a Dockerfile that can be used to reproduce the issue:

- for Pytest 7:
    ```bash
    > docker run --rm $(docker build -q --build-arg PYTEST_VERSION=7 .)
    ```
- for Pytest 8:
    ```bash
    docker run --rm $(docker build -q --build-arg PYTEST_VERSION=8.0.2 .)
    ```
