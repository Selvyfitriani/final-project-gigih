class User

    # Source valid email regex: https://www.youtube.com/watch?v=Ch-KRivqmzU
    # docs of regex: https://rubular.com/
    <<-RegexExplanation
        1. Regex is start with '/' and end with '/', but 'i' after '/' indicate insensitive case
        2. \A and \z at first and last respectively means regex must start and end with string.
        3. First part of email is \A([\w+\-].?)+ 
            a. [\w+\-] indicate first part must contain at least one characters (letter, number, underscore) and can have dash
            b. .? indicate first part can contain at most one any single character
            c. So, ([\w+\-].?)+ means first part of email must contain at least one character 
        4. Second Part is @[a-z\d\-]+
            a. Plus in the last means 'at least one'
            b. [a-z\d\-] means second part can contains letter, any digit (\d) and dash. It's for domain
            c. So, @[a-z\d\-]+ means second part must contain '@' followed by domain.
        5. Last Part is (\.[a-z]+)*\.[a-z]+
            a. \.[a-z]+ --> indicate second domain with format . followed by any letter
            b. * means at least zero. So, (\.[a-z]+)* means at least zero second domain
            c. \.[a-z]+ neans at least one second domain
            d. So, (\.[a-z]+)*\.[a-z]+ means last part must contain at least second domain
    RegexExplanation

    VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    def initialize(id=nil, username, email, bio_description)
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
    end

    def valid?
        return false if @username.empty?
        return false if (!valid_email?)
        return false if @bio_description.empty?
        return true
    end

    def valid_email? 
        return @email =~ VALID_EMAIL_REGEX
    end
end
