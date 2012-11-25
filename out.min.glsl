
#ifdef EXAMPLE_1_GLSL

#ifdef GL_ES
precision highp float;
#endif
uniform vec2 resolution;uniform float time;float a(vec3 b){return cos(b.x)+cos(b.y*1.5)+cos(b.z)+cos(b.y*20.)*.05;}float c(vec3 b){return min(a(b),1.);}vec3 d(vec3 b){vec3 e=vec3(.01,0,0);return normalize(vec3(c(b+e.xyy),c(b+e.yxy),c(b+e.yyx)));}void main(void){vec2 f=-1.0+2.0*gl_FragCoord.xy/resolution.xy;f.x*=resolution.x/resolution.y;vec4 g=vec4(1.9);vec3 h=vec3(sin(time)*.5,cos(time*.5)*.25+.25,time),i=normalize(vec3(f.x*1.6,f.y,1.0)),b=h,j;float k=.0;for(int l=0;l<64;l++){k=c(b);b+=k*i;}j=b;float e=length(b-h)*0.02;i=reflect(i,d(b));b+=i;for(int l=0;l<64;l++){k=c(b);b+=k*i;}g=max(dot(d(b),vec3(.1,.1,.0)),.0)+vec4(.3,cos(time*.5)*.5+.5,sin(time*.5)*.5+.5,1.)*min(length(b-h)*.04,1.);vec4 m=((g+vec4(e))+(1.-min(j.y+1.9,1.))*vec4(1.,.8,.7,1.))*min(time*.5,1.);gl_FragColor=vec4(m.xyz,1.0);}
#endif /* example_1.glsl */

#ifdef EXAMPLE_2_GLSL

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;uniform vec2 mouse;uniform vec2 resolution;float a(vec2 b,vec2 c){return b.x*c.y-c.x*b.y;}vec2 d(vec2 e,vec2 f,vec2 g){float b=a(e,g),c=2.0*a(f,e),h=2.0*a(g,f);float i=c*h-b*b;vec2 j=g-f,k=f-e,l=g-e;vec2 m=2.0*(c*j+h*k+b*l);m=vec2(m.y,-m.x);vec2 n=-i*m/dot(m,m);vec2 o=e-n;float p=a(o,l),q=2.0*a(k,o);float r=clamp((p+q)/(2.0*b+c+h),0.0,1.0);return mix(mix(e,f,r),mix(f,g,r),r);}void main(void){vec2 s=gl_FragCoord.xy;vec2 t[3];float u=1.0;t[0]=vec2(resolution.x*.30,resolution.y*.4);t[1]=mouse*resolution;t[2]=vec2(resolution.x*.60,resolution.y*.6);t[1]+=(t[1]-((t[0]+t[2])*0.5));vec2 v=d(t[0]-s,t[1]-s,t[2]-s);float h=length(v);float w=4.0*u;h=min(h,length(mouse*resolution-s)-w);h=min(h,length(t[0]-s)-w);h=min(h,length(t[2]-s)-w);h=clamp(h,0.0,1.0);h=mix(0.8,0.5,h);gl_FragColor=vec4(h,h,h,1.0);}
#endif /* example_2.glsl */
