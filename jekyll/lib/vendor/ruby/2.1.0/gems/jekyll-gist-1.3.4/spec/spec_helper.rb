TEST_DIR = File.dirname(__FILE__)
TMP_DIR  = File.expand_path("../tmp", TEST_DIR)

require 'webmock/rspec'
require 'cgi'
require 'jekyll'
require File.expand_path("../lib/jekyll-gist.rb", TEST_DIR)

Jekyll.logger.log_level = :error
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  def tmp_dir(*files)
    File.join(TMP_DIR, *files)
  end

  def source_dir(*files)
    tmp_dir('source', *files)
  end

  def dest_dir(*files)
    tmp_dir('dest', *files)
  end

  def doc_with_content(content, opts = {})
    my_site = site
    Jekyll::Document.new(source_dir('_test/doc.md'), {site: my_site, collection: collection(my_site)})
  end

  def collection(site, label = 'test')
    Jekyll::Collection.new(site, label)
  end

  def site(opts = {})
    conf = Jekyll::Utils.deep_merge_hashes(Jekyll::Configuration::DEFAULTS, opts.merge({
      "source"      => source_dir,
      "destination" => dest_dir
    }))
    Jekyll::Site.new(conf)
  end
end
