type Service_definitions::Service = Struct[{
    port        => Stdlib::Port,
    protocols   => Array[Enum['udp', 'tcp', 'ddp']],
    description => Optional[String[1]],
    aliases     => Optional[Array[Pattern[/\w+/]]],
}]
