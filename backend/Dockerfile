FROM python:3.10.20-alpine3.22

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT ["python"]

CMD ["app.py"]