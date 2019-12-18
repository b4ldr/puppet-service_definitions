service_definition{'foobar':
    port        => 1337,
    protocols   => ['udp','tcp'],
    description => 'testing',
    aliases     => ['leet','hacker']
}
service_definition{'testudp':
    port        => 2222,
    protocols   => ['udp'],
}
service_definition{'testtcp':
    port        => 3333,
    protocols   => ['tcp'],
}
service_definition{'testddp':
    port        => 4444,
    protocols   => ['ddp'],
}
service_definition{'testalias':
    port        => 5555,
    protocols   => ['udp'],
    aliases => ['foobar'],
}
service_definition{'testdescr':
    port        => 6666,
    protocols   => ['tcp'],
    description => 'foobar',
}
