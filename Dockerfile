
# # Use the AWS Lambda Python base image
# FROM public.ecr.aws/lambda/python:3.12
#
# # Copy requirements and install dependencies
# COPY requirements.txt ${LAMBDA_TASK_ROOT}
# RUN pip install --no-cache-dir -r requirements.txt
#
# # Copy application code into the container
# COPY main.py ${LAMBDA_TASK_ROOT}
#
# # Set the CMD to your handler (file.function)
# CMD ["main.handler"]

# 1️⃣ Use an official Python base image
FROM python:3.10-slim

# 2️⃣ Set the working directory inside the container
WORKDIR /app
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 3️⃣ Copy only requirements first (to optimize Docker caching)
COPY requirements.txt .

# 4️⃣ Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5️⃣ Copy the rest of the application code
COPY . .

# 6️⃣ Expose the port FastAPI will run on
EXPOSE 8000

# 7️⃣ Command to run the FastAPI app using Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
