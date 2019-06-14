# Gcloud::Datastore::Activesupport
Use Google Datastore as Cache for Ruby on Rails application.

## Usage
How to use the plugin:

```ruby

  config.cache_store = :gcloud_datastore

```
Enviroment variable GOOGLE_CLOUD_PROJECT required.


Alternately:

```ruby

  config.cache_store = :gcloud_datastore, {
      project_id: "gcloud-project-slug-name"
  }

```

Sometimes credential file is needed (for example in local development):

```ruby

  config.cache_store = :gcloud_datastore, {
      project_id: "gcloud-project-slug-name",
      credential_file_json: "/path/to/credential_file.json"
  }

```

or set enviroment variable: GOOGLE_APPLICATION_CREDENTIALS
```bash
export GOOGLE_APPLICATION_CREDENTIALS /path/to/credential_file.json
```

## Credential file configuration

https://developers.google.com/accounts/docs/application-default-credentials

https://console.cloud.google.com/apis/credentials/serviceaccountkey


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'gcloud-datastore-activesupport'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install gcloud-datastore-activesupport
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
