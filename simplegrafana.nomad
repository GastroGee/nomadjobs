job "grafana" {
  datacenters = ["dc1"]
  
  type = "service"

  group "grafana" {
    count = 1  
    restart {
      attempts = 10
      interval = "5m"
      delay = "10s"
      mode = "delay"
    }
    network {
      port "http" {
        static = "3000"
      }
    }
    service {
        name = "grafana"
        port = "http"
        check {
            name     = "Grafana HTTP"
            type     = "http"
            path     = "/api/health"
            interval = "5s"
            timeout  = "2s"
            check_restart {
                limit = 2
                grace = "60s"
                ignore_warnings = false
            }
        }
    }
    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:latest"

        ports = ["http"]
      }

      resources {
        cpu    = 200 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}