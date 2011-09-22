
# Exemple de mashup polyglotte avec SPORE

---

# SPORE

## SPecifications for a POrtable Rest Environment

> "SPORE is a specification for describing REST API that can be parsed and used automatically by clients implementations to communicate with the described API."

 * Créé par Franck Cuny et Nils Grünwald au sein de Linkfluence.
 * Première release il y a 1 an à l'OSDC.fr 2010 :)

---

# Pourquoi ?

Chez Linkfluence, on développe des moteurs de captation/traitement de données issues du web social.

 * Système distribué d'agents dans plusieurs langages
 * Communications avec bases, outils externes, etc. en REST
 * Write once, deploy everywhere 

---

# Une spec ?

[https://dev.twitter.com/docs/api/1/get/search](https://dev.twitter.com/docs/api/1/get/search)

    !javascript
    {
        "base_url" : "http://search.twitter.com/",
        "methods" : {
            "search" : {
                "path" : "/search.:format",
                "method" : "GET",
                "required_params" : [
                    "format",
                    "q"
                ],
                "optional_params" : [
                    "geocode",
                    "lang",
                    "locale",
                    "page",
                    "result_type"
                 ]
            }
        }
    }

---

# Middlewares



 * Formats
 * Authenfication
 * Cache
 * Gestion des headers

---

# Perl

    !perl
    use Net::HTTP::Spore;
    use Try::Tiny;

    my $client = Net::HTTP::Spore->new(
        '/path/to/spec.json',
        base_url => 'http://base_url/', # Optional
    );
    $client->enable( 'Format::JSON' );

    my $res;
    try {
        $res = $client->search( format => 'json', q => 'osdc' );
    }
    catch {
        warn $_;
    };

    say $_->{ text } for( @{ $res->body->{ results } } );

 * Client complet (en prod).
 * Développé chez Linkfluence par Franck Cuny.
 * Net-HTTP-Spore est dispo sur [CPAN](https://metacpan.org/module/Net::HTTP::Spore) et sur [GitHub](https://github.com/franckcuny/net-http-spore).

---

# Lua

    !lua
    local Spore = require 'Spore'

    local client = Spore.new_from_spec '/path/to/spec.json'
    client:enable 'Format.JSON'

    local res = client:search{ format = 'json', q = 'osdc' }

    for t in res.body.results do
        print( t.text )
    end

 * Client complet (en prod ?).
 * Développé par François Perrad.
 * lua-Spore est dispo sur [LuaForge](http://luaforge.net/projects/lua-spore/files/) (luarocks) et sur [GitHub](http://github.com/fperrad/lua-Spore/downloads/).

---

# Ruby

    !ruby
    require 'spore'
    require 'spore/middleware/format'

    client = Spore.new(
        '/path/to/spec.json',
        { :base_url => 'http://base_url/' } 
    )
    client.enable(Spore::Middleware::Format)

    res = begin
        client.search( :format => 'json', :q => 'osdc' )
    rescue
        raise $!
    end

    res.body.results.each do |t|
        puts t.text
    end

 * Client complet (en prod).
 * Développé chez Weborama par Sukria.
 * Ruby-Spore est dispo sur [GitHub](https://github.com/sukria/Ruby-Spore).

---

# nodejs

    !javascript
    var spore = require( 'spore' );
    var client = spore.createClient( __dirname + '/path/to/spec.json' );
    client.enable( spore.middlewares.json() ); 

    client.search( { format: 'json', q: 'osdc' }, function( err, res ) {
        if ( err ) 
            throw err;
        for( i in res.body.results ){
            console.log( res.body.results[i].text );
        };    
    } );

 * Client complet (en prod ?).
 * Développé chez AF83 par François de Metz.
 * node-spore est dispo sur [npm](http://search.npmjs.org/#/spore) et sur [GitHub](https://github.com/francois2metz/node-spore).

---

# JQuery

    !html
    <script type="text/javascript" src="jquery-spore/spore.js"></script>
    <script type="text/javascript">
        var client  = spore.create(twitter_spec,function(a){ client=a });

        client.search(
            { "format": "json", "q": query },
            function( res, req ) {
                for( var i in d.results ) {
                    var t = d.results[i];
                    $( '<li>' )
                        .text( t.text )
                        .appendTo( '#result > ul' );
                }
	        }, 
            function( req ) {
		        alert( req );
	        }
        );

    </script>

 * Fonctionne uniquement en JSONP
 * Pas de support des middlewares pour le moment
 * Développé chez Linkfluence par Niko.
 * jquery-spore est dispo sur [GitHub](https://github.com/nikopol/jquery-spore)

---

# Clojure

    !clojure
    (use '(clj-spore) '(clj-spore.middleware))
    (def client (load-spec-from-file "/path/to/spec.json"
                                 :middlewares [wrap-json-format]
                                 :overload {:base_url "http://base_url/"}))
    (try
        (let [res ((client :search) :format "json" :q "osdc")]
            (doseq [item (:decoded-body res)] (println (item :text))))
        (catch Exception e (println (.getMessage e))))

 * Client complet (en prod)
 * Développé chez Linkfluence par Nils Grünwald.
 * clj-spore est dispo sur [GitHub](https://github.com/ngrunwald/clj-spore)

---

# Autre langages

## Java et autres langages sur JVM 
  * Client Clojure (pour le moment)
  * Un vrai client Java en cours par Nils Grünwald

## Python  
  * Client en cours par Franck Cuny

## Autres 
  * PHP (?)
  * C++, Haskell, Go : à faire ;)

---

# Specs existantes

## Services

Amazon S3 / Bitly (pr) / Facebook (Graph et REST) / GeoNames / GitHub / 
GoogleOAuth / Google (Maps, PageSpeed, Shortener, Translate) / Gnip / 
HackerNews / IndexTank / Intervals / LinkedIn / Ohloh / OpenCalais / 
SoundCloud (pr) / Superfeedr / Syllabs (pr) / Topsy (pr) / Twitter / 
TwitterSearch

## Apps

CouchDB / Presque (système de message inspiré de resque) / Redmine

---

# Google APIs Discovery

  * Specs plus simples :
    * [Google APIs Discovery](https://www.googleapis.com/discovery/v1/apis/urlshortener/v1/rest)
    * [SPORE](https://github.com/SPORE/api-description/blob/master/services/googleshortener.json)
  * Souplesse : pas de compilation    

  * Google APIs Discovery n'existe aujourd'hui que pour les APIs Google

  * SPORE est compatible (on peut générer des specs Google APIs Discovery à partir de specs SPORE)

---

# Infos

  * Les specs et les descriptions d'API sont sur GitHub ([https://github.com/SPORE](https://github.com/SPORE))
  * Tous les projets aussi
  * Donc **"fork"** puis **"pull request"** :)

  * Un GoogleGroup : [https://groups.google.com/group/spore-rest](https://groups.google.com/group/spore-rest)

---

# Remerciements

  * Dancer - a micro web application framework for Perl - [http://perldancer.org/](http://perldancer.org/)
  * François Perrad, Sukria et Weborama, François de Metz et AF83
  * Tous ceux qui écrivent des specs :)
  * Tous ceux qui utilisent SPORE !
  
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

![Linkfluence](logo.png) 

