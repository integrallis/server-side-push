require 'sinatra'
require 'json' 

set :server, 'thin'

get '/' do
  erb :index
end 

get '/stream' do     
  stream do |out|  
    (10..100).step(2) do |n|   
      out << gimme_funny_word.to_json
      sleep 1.5      
    end
  end
end   

# http://www.alphadictionary.com/articles/100_funniest_words.html
FUNNY_WORDS = [
  {'Abibliophobia' => "The fear of running out of reading material."},
  {'Absquatulate' => "To leave or abscond with something."},
  {'Allegator' => "Some who alleges."},
  {'Anencephalous' => "Lacking a brain."},
  {'Argle-bargle' => "A loud row or quarrel."},
  {'Batrachomyomachy' => "Making a mountain out of a molehill."},
  {'Billingsgate' => "Loud, raucous profanity."},
  {'Bloviate' => "To speak pompously or brag."},
  {'Blunderbuss' => "A gun with a flared muzzle or disorganized activity."},
  {'Borborygm' => "A rumbling of the stomach."},
  {'Boustrophedon' => "A back and forth pattern."},
  {'Bowyang' => "A strap that holds the pants legs in place."},
  {'Brouhaha' => "An uproar."},
  {'Bumbershoot' => "An umbrella."},
  {'Callipygian' => "Having an attractive rear end or nice buns."},
  {'Canoodle ' => "To hug and kiss."},
  {'Cantankerous' => "Testy, grumpy."},
  {'Catercornered' => "Diagonal(ly)."},
  {'Cockalorum' => "A small, haughty man."},
  {'Cockamamie' => "Absurd, outlandish."},
  {'Codswallop' => "Nonsense, balderdash."},
  {'Collop' => "A slice of meat or fold of flab."},
  {'Collywobbles' => "Butterflies in the stomach."},
  {'Comeuppance' => "Just reward, just deserts."},
  {'Crapulence' => "Discomfort from eating or drinking too much."},
  {'Crudivore ' => "An eater of raw food."},
  {'Discombobulate' => "To confuse."},
  {'Donnybrook' => "An melee, a riot."},
  {'Doozy ' => "Something really great."},
  {'Dudgeon' => "A bad mood, a huff."},
  {'Ecdysiast' => "An exotic dancer, a stripper."},
  {'Eructation' => "A burp, belch."},
  {'Fard' => "Face-paint, makeup."},
  {'Fartlek' => "An athletic training regime."},
  {'Fatuous' => "Unconsciously foolish."},
  {'Filibuster' => "Refusal to give up the floor in a debate to prevent a vote."},
  {'Firkin' => "A quarter barrel or small cask."},
  {'Flibbertigibbet' => "Nonsense, balderdash."},
  {'Flummox' => "To exasperate."},
  {'Folderol' => "Nonsense."},
  {'Formication' => "The sense of ants crawling on your skin."},
  {'Fuddy-duddy' => "An old-fashioned, mild-mannered person."},
  {'Furbelow' => "A fringe or ruffle."},
  {'Furphy' => "A portable water-container."},
  {'Gaberlunzie' => "A wandering beggar."},
  {'Gardyloo!' => "A warning shouted before throwing water from above."},
  {'Gastromancy' => "Telling fortune from the rumblings of the stomach."},
  {'Gazump' => "To buy something already promised to someone else."},
  {'Gobbledygook' => "Nonsense, balderdash."},
  {'Gobemouche' => "A highly gullible person."},
  {'Godwottery' => "Nonsense, balderdash."},
  {'Gongoozle' => "To stare at, kibitz."},
  {'Gonzo' => "Far-out journalism."},
  {'Goombah' => "An older friend who protects you."},
  {'Hemidemisemiquaver' => "A musical timing of 1/64."},
  {'Hobbledehoy' => "An awkward or ill-mannered young boy."},
  {'Hocus-pocus' => "Deceitful sleight of hand."},
  {'Hoosegow' => "A jail or prison."},
  {'Hootenanny' => "A country or folk music get-together."},
  {'Jackanapes' => "A rapscallion, hooligan."},
  {'Kerfuffle' => "An uproar, mild scandal."},
  {'Klutz' => "An awkward, stupid person."},
  {'La-di-da' => "An interjection indicating that something is pretentious."},
  {'Lagopodous' => "Like a rabbit's foot."},
  {'Lickety-split' => "As fast as possible."},
  {'Lickspittle' => "A servile person, a toady."},
  {'Logorrhea' => "Loquaciousness, talkativeness."},
  {'Lollygag' => "To move slowly, fall behind."},
  {'Malarkey' => "Nonsense, balderdash."},
  {'Maverick' => "A loner, someone outside the box."},
  {'Mollycoddle' => "To treat too leniently."},
  {'Mugwump' => "An independent politician who does not follow any party."},
  {'Mumpsimus' => "An outdated and unreasonable position on an issue."},
  {'Namby-pamby' => "Weak, with no backbone."},
  {'Nincompoop' => "A foolish person."},
  {'Oocephalus' => "An egghead."},
  {'Ornery' => "Mean, nasty, grumpy."},
  {'Pandiculation' => "A full body stretch."},
  {'Panjandrum' => "Someone who thinks himself high and mighty."},
  {'Pettifogger' => "A person who tries to befuddle others with his speech."},
  {'Pratfall' => "A fall on one's rear."},
  {'Quean' => "A disreputable woman."},
  {'Rambunctious' => "Aggressive, hard to control."},
  {'Ranivorous' => "Frog-eating"},
  {'Rigmarole' => "Nonsense, unnecessary complexity."},
  {'Shenanigan' => "A prank, mischief."},
  {'Sialoquent' => "Spitting while speaking."},
  {'Skedaddle' => "To hurry somewhere."},
  {'Skullduggery' => "No good, underhanded dealing."},
  {'Slangwhanger' => "A loud abusive speaker or obnoxious writer."},
  {'Smellfungus' => "A perpetual pessimist."},
  {'Snickersnee' => "A long knife."},
  {'Snollygoster' => "A person who can't be trusted."},
  {'Snool' => "A servile person."},
  {'Tatterdemalion' => "A child in rags."},
  {'Troglodyte' => "Someone or something that lives in a cave."},
  {'Turdiform' => "Having the form of a lark."},
  {'Unremacadamized' => "Having not been repaved with macadam."},
  {'Vomitory' => "An exit or outlet."},
  {'Wabbit' => "Exhausted, tired, worn out."},
  {'Widdershins' => "In a contrary or counterclockwise direction."},
  {'Yahoo' => "A rube, a country bumpkin."}
] 

def gimme_funny_word 
  FUNNY_WORDS.sample.first
end
                                               