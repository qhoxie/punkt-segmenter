module Punkt
  class LanguageVars

    attr_reader :re_period_context
    attr_reader :sent_end_chars
    attr_reader :internal_punctuation
    attr_reader :re_boundary_realignment
    
    def initialize
      @sent_end_chars = ['.', '?', '!']

      @re_sent_end_chars = Oniguruma::ORegexp.new("[.?!]")

      @internal_punctuation = [',', ':', ';']

      @re_boundary_realignment = Oniguruma::ORegexp.new('^["\')\]}]+?(?:\s+|(?=--)|$)', 'm', 'utf8')

      @re_word_start = Oniguruma::ORegexp.new('[^\(\"\`{\[:;&\#\*@\)}\]\-,]')

      @re_non_word_chars = Oniguruma::ORegexp.new('(?:[?!)\";}\]\*:@\'\({\[])')

      @re_multi_char_punct = Oniguruma::ORegexp.new('(?:\-{2,}|\.{2,}|(?:\.\s){2,}\.)')

      @re_word_tokenizer = Oniguruma::ORegexp.new(%{#{@re_multi_char_punct}|(?=#{@re_word_start})\\S+?(?=\\s|$|#{@re_non_word_chars}|#{@re_multi_char_punct}|,(?=$|\\s|#{@re_non_word_chars}|#{@re_multi_char_punct}))|\\S})

      @re_period_context = Oniguruma::ORegexp.new(%{\\S*#{@re_sent_end_chars}(?=(?<after_tok>#{@re_non_word_chars}|\\s+(?<next_tok>\\S+)))})
    end

    def word_tokenize(text)
      md = @re_word_tokenizer.scan(text) || []
      md.map(&:to_s)
    end
  
  end
end
