#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// From "Random-Access Rendering of General Vector Graphics"
// posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float det(vec2 a, vec2 b) { return a.x*b.y-b.x*a.y; }

vec2 get_distance_vector(vec2 b0, vec2 b1, vec2 b2)
{
	float a=det(b0,b2), b=2.0*det(b1,b0), d=2.0*det(b2,b1);
	float f=b*d-a*a;
	vec2 d21=b2-b1, d10=b1-b0, d20=b2-b0;
	vec2 gf=2.0*(b*d21+d*d10+a*d20);
	gf=vec2(gf.y,-gf.x);
	vec2 pp=-f*gf/dot(gf,gf);
	vec2 d0p=b0-pp;
	float ap=det(d0p,d20), bp=2.0*det(d10,d0p);
	float t=clamp((ap+bp)/(2.0*a+b+d), 0.0,1.0);
	return mix(mix(b0,b1,t),mix(b1,b2,t),t);
}

void main(void)
{
	vec2 position = gl_FragCoord.xy;
	vec2 p[3];
	float s = 1.0;//resolution.x/1920.0;
	
	p[0] = vec2(resolution.x*.30,resolution.y*.4);
	p[1] = mouse*resolution;
	p[2] = vec2(resolution.x*.60,resolution.y*.6);

	// make the bez pass thru the control point (THX)
	p[1]+=(p[1]-((p[0]+p[2])*0.5));
	
	vec2 xy = get_distance_vector(p[0]-position, p[1]-position, p[2]-position);
	float d = length(xy);
	
	//d -= 8.0;	// Thickness
	//d = abs(d);	// Outline
	//d *= 1.0/2.0;	// softness
	
	// Curve Control point
	float r = 4.0*s;
	d = min(d, length(mouse*resolution - position) - r);
	d = min(d, length(p[0] - position) - r);
	d = min(d, length(p[2] - position) - r);
	
	d = clamp(d, 0.0, 1.0);
	d = mix(0.8, 0.5, d);
	gl_FragColor = vec4(d,d,d, 1.0);

}