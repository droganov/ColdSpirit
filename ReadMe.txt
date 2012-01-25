Installation
1. Copy "skeleton" folder contents to the webroot

2. Copy "spirit" folder to the webroot or map it as /spirit in Railo admin. If you use spirit for production, make sure /spirit/admin is not accessible from the Web.

3. ColdSpirit requires some rewrite rules:
	3.1 Apache (rewrites and proxies everything to Tomcat):

	<VirtualHost *:80>
		ServerName test.dev
		ProxyPreserveHost On
		ProxyPass / ajp://127.0.0.1:8009/
		ProxyPassReverse / ajp://127.0.0.1:8009/

		RewriteEngine On
		RewriteRule  ^([^.]+)$ ajp://127.0.0.1:8009/index.cfm?vars=$1 [P]
	</VirtualHost>

	3.2 Nginx (Used for production):
	server {                                
	    listen       80;                                                                                                    
	    server_name  www.site.com;
	    error_page  404  /error/404;
	    root   /var/www/vhosts/site.com/public_html;
	    index  index.cfm index.html;
	    client_max_body_size 5m;
	
	    location / {
			rewrite  ^([^.]+)$  /index.cfm?vars=$1  last;                                                                                          
	    }
    
	    location /root {                                                                                                                  
	        rewrite ^/(.*)  / permanent;                                                                    
	    }

	    location ~ /(WEB-INF|app/|\.ht|.*(Application|OnRequestEnd).(cfm|cfc)) {
	        deny all;
	    }
                                                                                       
	    location ~ \.(cfm|cfc)$ {                                                                                                              
	        proxy_pass   http://127.0.0.1:8600;                                                                                                
	        proxy_redirect     off;
	        proxy_intercept_errors on;
	        proxy_set_header   Host             $host;
	        proxy_set_header   X-Real-IP        $proxy_add_x_forwarded_for;
	        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;                                                                                                  
	    }                                                                                                                                
	}
	
4. Spirit webadmin can be found at /spirit/admin/index.cfm. Use spirit admin to create views, states, add controllers and templates.

5. Routing
Default routing rule is: site.com/view_name/state_name if no overrides made with settings.

To pass some extra variables simply add values divided by slash: site.com/view_name/state_name/my_var_1/my_var_2

Url vars should be picked up with the spirit get function. If not 404 thrown.

example: myVar = event.target.get(3, "hello");

Spirit will use the third var in the url and use "hello" as a default value if variable is not passed.
If default value is numeric, Spirit will try to parse the value as an integer.

More to come...