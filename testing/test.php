<?php

class Test 
{
    public $sock;
    
    function __construct($host)
    {
        try {
            $this->sock = fsockopen('tcp://'.$host, 25);    
        } catch (Exception $e) {
            echo $e;
        }
        
    }
    
    function send($str)
    {
        fwrite($this->sock, $str);
    }    
    
    function read() 
    {
        return trim(fgets($this->sock, 200));        
    }
    
    function io($str) {
        echo $str."\n";
        $this->send($str."\n");
        echo \trim($this->read())."\n";
    }

    function close()
    {
        fclose($this->sock);
    }
    
}


for($i=0;$i<100;$i++) {
	$t = new Test('172.18.0.3');
	$t->io("HELO localhost");
	$t->io("MAIL FROM: foo@bar.com");
	$t->io("RCPT TO: test.user@example.com");
	$t->io("DATA");
	$t->send(file_get_contents('./message.msg'));
	$t->send("\n");
	$t->send('.');
	$t->send("\r\n");
	$t->io("QUIT\n");
	$t->close();
}
