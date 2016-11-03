$LookFor = @{
    "Hostname" = @{
        "LookForString" = "client-hostname*"
        "StringSplitPos" = @(1)
    }
    "Mac" = @{
        "LookForString" = "hardware ethernet*"
        "StringSplitPos" = @(2)
    }
    "IPAddress" = @{
        "LookForString" = "lease*"
        "StringSplitPos" = @(1)
    }
    "LeaseStart" = @{
        "LookForString" = "starts*"
        "StringSplitPos" = @(2, 3)
        "Special" = "GET_DATE pos1/pos2"
    }
    "LeaseEnd" = @{
        "LookForString" = "ends*"
        "StringSplitPos" = @(2, 3)
        "Special" = "GET_DATE pos1/pos2"
    }
}
