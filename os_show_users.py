import os
from keystoneclient.v2_0.client import Client

client = Client(
    username=os.environ['OS_USERNAME'],
    password=os.environ['OS_PASSWORD'],
    tenant_name=os.environ['OS_TENANT_NAME'],
    auth_url=os.environ['OS_AUTH_URL']
)

for tenant in client.tenants.list():
    print "Project:", tenant.name
    users = [u.name for u in client.users.list(tenant_id=tenant.id)]
    print "Project members:", ", ".join(users)
    print
