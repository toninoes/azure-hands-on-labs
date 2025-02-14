# Usar la última imagen base oficial de Python
FROM python:3.13

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos requeridos a la imagen
COPY requirements.txt requirements.txt
COPY src/app.py .
COPY src/templates ./templates

# Instalar las dependencias
RUN apt-get update
RUN pip install -r requirements.txt

# Exponer el puerto 80
EXPOSE 80

# Comando para correr Gunicorn
CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:80", "app:app"]
