
Pod::Spec.new do |s|
  s.name             = 'HQQVRPlayer'
  s.version          = '0.3.0'
  s.summary          = 'A lightweight vr library for plays panoramas and videos.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.A lightweight vr library for plays panoramas and videos.
                       DESC

  s.homepage         = 'https://github.com/huangqiangqiang/HQQVRPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangqiangqiang' => '285086598@163.com' }
  s.source           = { :git => 'https://github.com/huangqiangqiang/HQQVRPlayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'HQQVRPlayer/Classes/*.{h,m}'
  s.resource  = "HQQVRPlayer/Classes/HQQVRResource.bundle"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'GLKit'
end
