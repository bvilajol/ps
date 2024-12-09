from diagrams import Cluster, Diagram
from diagrams.onprem.network import Nginx
from diagrams.onprem.client import Users

with Diagram("Network Diagram", show=False, direction="TB"):

    client = Users("users")

    with Cluster("Frontend"):
        lb = Nginx("ingress_lb")

    with Cluster("Backend"):
        app = [ Nginx("app1"), Nginx("app2")] 

    client >> lb >> app