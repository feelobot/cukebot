class Parser
  ##################################################
  ## Sample Input:
  # OGUXYCDI: Dan has completed a deploy of nikse/master-15551-the-web-frontpage-redux to stag_br5. Github Hash is 96dd307. Took 5 mins and 25 secs
  ##################################################

  def self.slack(params)
    text = (params["text"])
    params["deploy_id"] = text.match(/^(.*):/)[1]
    params["branch"] = text.match(/of\s(.*)\sto/)[1]
    params["repo"] = text.match(/to.*_(.*?)\d\./)[1]
    params["cluster"] = text.match(/to(.*?)_.*\d\./)[1]
    params["env"] = text.match(/to\s.*_.*?(\d)\./)[1]
    params["suite"] = set_suite(params["repo"]) 
    params["hash"] = text.match(/is\s(.*?)\./)[1]
    puts params.inspect
    return params
  end

  def self.set_suite(repo)
    "sanity" if repo == "br"
  end
end
