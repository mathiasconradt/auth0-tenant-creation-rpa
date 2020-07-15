# +
from RPA.Robocloud.Secrets import Secrets

secrets = Secrets()
AUTH0_USERNAME = secrets.get_secret("AUTH0")["AUTH0_USERNAME"]
AUTH0_PASSWORD = secrets.get_secret("AUTH0")["AUTH0_PASSWORD"]
