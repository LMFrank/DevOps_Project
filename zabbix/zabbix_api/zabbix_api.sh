curl -XPOST -H "Content-Type: application/json-rpc" -d '
{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password": "Chiway@123"
    },
    "id": 1,
    "auth": null
}' http://172.16.2.138/zabbix/api_jsonrpc.php | python3 -m json.tool



curl -XPOST -H "Content-Type: application/json-rpc" -d '
{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": [
            "hostid",
            "host"
        ],
        "selectInterfaces": [
            "interfaceid",
            "ip"
        ]
    },
    "id": 1,
    "auth": "b8beac4868492a0e84cb49e2abe693b7" 
}' http://172.16.2.138/zabbix/api_jsonrpc.php | python3 -m json.tool