FROM python:3.12-slim
WORKDIR /home
COPY tests/ /home/tests/
ARG PYTEST_MAJOR_VERSION
RUN pip install "pytest==${PYTEST_MAJOR_VERSION}"
CMD pytest tests/test_one.py tests --collect-only