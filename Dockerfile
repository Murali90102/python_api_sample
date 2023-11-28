FROM python:3.9.18-alpine3.18
WORKDIR /app
COPY app/* /app/.
RUN pip install -r requirements.txt
# RUN python -m unittest test_main.py
CMD [ "python", "-m", "uvicorn" , "main:app" ]