FROM  ruby:2.6.5

# Set local timezone

# Install your app's runtime dependencies in the container
RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y 


ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list


RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -qq -y --no-install-recommends nodejs yarn

#the image has an out-of-date rake. Can't update it unless you're root, so we'll remove for now
RUN gem uninstall rake

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME


RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser
RUN chown -R appuser:appuser $APP_HOME
RUN mkdir /home/appuser
RUN chown -R appuser:appuser /home/appuser

USER appuser


RUN gem install rails
RUN gem install rake -v 12.3.3
RUN gem install minitest
RUN gem install active_type -v 1.3.0
RUN gem install public_suffix -v 4.0.1

# Copy the app's code into the container


# Configure production environment variables
ENV RAILS_ENV=development \
    RACK_ENV=development

# Expose port 3000 from the container
EXPOSE 3000

# Run puma server by default
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
