import sys
import langchain

def handler(event, context):
    return 'Hello from AWS Lambda using Python' + sys.version + '!' + "\n We are using:" + langchain.__version__