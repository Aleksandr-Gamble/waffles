
#~~~HUGGINGFACE~MODEL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from sentence_transformers import SentenceTransformer
model_name = 'multi-qa-MiniLM-L6-cos-v1'
model = SentenceTransformer(model_name)
vec_size = model.encode('Hello').shape[0]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~LAMBDA~HANDLER~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
def handler(event, context):
    text = event['text']
    vector = model.encode(text).tolist()
    return {'vector':vector}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
