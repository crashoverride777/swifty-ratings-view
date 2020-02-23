Pod::Spec.new do |s|

s.name = 'SwiftyRatingsControl'
s.version = '2.0.0'
s.license = 'MIT'
s.summary = 'A simple ratings control.'

s.homepage = 'https://github.com/crashoverride777/swifty-ratings-control'
s.social_media_url = 'http://twitter.com/overrideiactive'
s.authors = { 'Dominik' => 'overrideinteractive@icloud.com' }

s.requires_arc = true
s.ios.deployment_target = '11.4'
    
s.source = {
    :git => 'https://github.com/crashoverride777/swifty-ratings-control.git',
    :tag => s.version
}

s.source_files = "SwiftyRatingsControl/**/*.{swift}"

end
