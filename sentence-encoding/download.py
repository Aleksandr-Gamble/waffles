from sentence_transformers import SentenceTransformer
model_name = 'multi-qa-MiniLM-L6-cos-v1'
model = SentenceTransformer(model_name)
_ = model.encode('test') # will throw an error if something went wrong
