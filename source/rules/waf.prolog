header(server, "AkamaiNetStorage")
wafheader(akamai, "AkamaiNetStorage")

waf(X, Y) :- wafheader(X, Y), wafheader()

aHR0cHM6Ly9nb29nbGUuY29t

blocked(X, Y)
