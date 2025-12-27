FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime

RUN apt-get update && \
    apt-get install -y python3 python3-pip git ffmpeg libmagic-dev && \
    apt-get clean

WORKDIR /workspace/

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade setuptools wheel pip  && \
    pip install --no-cache-dir -r requirements.txt

# Check if this is needed 
# RUN python3 -m pytorch_lightning.utilities.upgrade_checkpoint ../usr/local/lib/python3.10/dist-packages/whisperx/assets/pytorch_model.bin

RUN sed -i 's/^[[:space:]]*weights_only=weights_only,/            weights_only=False,/' /usr/local/lib/python3.10/dist-packages/lightning_fabric/utilities/cloud_io.py 

COPY . .

EXPOSE 8080

CMD ["python3", "clipsaiserver.py"]
