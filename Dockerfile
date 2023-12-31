FROM python:3.9.18-alpine3.18
WORKDIR /app
COPY app/* /app/.
RUN pip install -r requirements.txt
# RUN python -m unittest test_main.py
# CMD [ "python", "-m", "uvicorn" , "main:app", "--host", "0.0.0.0", "--port", "8000" ]

EXPOSE 8000
# CMD python -m uvicorn main:app --host 0.0.0.0 --port 8000
CMD python -m uvicorn main:app --host 0.0.0.0 --port ${APP_PORT}
