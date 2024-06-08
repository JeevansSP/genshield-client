
export http_proxy="http://localhost:8080" 
export https_proxy="http://localhost:8080"

nohup mitmdump -p 8080 -s "./interceptor.py" > ~/mitmdump.log 2>&1 &

                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
