Pod::Spec.new do |s|

s.name = 'SwiftyRatingsView'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'A simple ratings view.'
s.homepage = 'https://github.com/crashoverride777/swifty-ratings-view'
s.social_media_url = 'http://twitter.com/overrideiactive'
s.authors = { 'Dominik' => 'overrideinteractive@icloud.com' }

s.requires_arc = true
s.ios.deployment_target = '10.3'
    
s.source = {
    :git => 'https://github.com/crashoverride777/swifty-ratings-view.git',
    :tag => s.version
}

s.source_files = "SwiftyRatingsView/Source/**/*.{swift}"

end