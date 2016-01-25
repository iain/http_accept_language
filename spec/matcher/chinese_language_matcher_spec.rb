require 'http_accept_language/matcher/chinese_language_matcher'

describe HttpAcceptLanguage::Matcher::ChineseLanguageMatcher do
  let(:matcher) { HttpAcceptLanguage::Matcher::ChineseLanguageMatcher.new(available) }

  it "handles any language with the Chinese language subtag" do
    expect(HttpAcceptLanguage::Matcher::ChineseLanguageMatcher.matching_languages).to include('zh')
  end

  it "handles any language with the Mandarin extended language subtag" do
    expect(HttpAcceptLanguage::Matcher::ChineseLanguageMatcher.matching_languages).to include('cmn')
  end

  it "handles any language with the Cantonese extended language subtag" do
    expect(HttpAcceptLanguage::Matcher::ChineseLanguageMatcher.matching_languages).to include('yue')
  end

  context "when the available languages have only region subtags" do
    context "and the available languages do not contain the default language for any script" do
      let(:available) { %w{en-US zh-MO zh-HK} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq(preferred)
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-CN' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-Hans' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches the region subtag" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-HK')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-HK' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language contains an extended language subtag" do
        context "and the preferred language also contains a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'zh-cmn' }

            it "returns nil" do
              expect(matcher.match(preferred)).to be_nil
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'zh-yue' }

            it "returns the first available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-MO')
            end
          end
        end

        context "and the preferred language does not contain a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'cmn' }

            it "returns nil" do
              expect(matcher.match(preferred)).to be_nil
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'yue' }

            it "returns the first available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-MO')
            end
          end
        end

        context "and the preferred language also contains a region subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end
          end
        end

        context "and the preferred language contains a script subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-MO')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-MO')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-MO')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-MO')
              end
            end
          end
        end

        context "and the preferred language contains both a region subtag and a script subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-HK')
              end
            end
          end
        end
      end
    end

    context "and the available languages contain the default language for the preferred language's script" do
      let(:available) { %w{en-US zh-MO zh-TW} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-MO' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq(preferred)
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the default langauge matching its script" do
            expect(matcher.match(preferred)).to eq('zh-TW')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-CN' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-TW')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-Hans' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches the region subtag" do
          let(:preferred) { 'zh-Hant-MO' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-TW')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-TW' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end
    end

    context "and the available languages contain the default language for a script that does not match the preferred language's script" do
      let(:available) { %w{en-US zh-MO zh-HK zh-CN} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq(preferred)
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches the region subtag" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-HK')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-MO')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-HK' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-CN')
          end
        end
      end
    end
  end

  context "when the available languages have only script subtags" do
    let(:available) { %w{en-US zh-Hant} }

    context "and the preferred language has only a region subtag" do
      context "and the preferred language matches the script of an available language" do
        let(:preferred) { 'zh-HK' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq('zh-Hant')
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zh-CN' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end

    context "and the preferred language has only a script subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'zh-Hant' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq('zh-Hant')
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zh-Hans' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end

    context "and the preferred language has both region and script subtags" do
      context "and the preferred language matches the script of an available language" do
        context "and the script of the preferred language matches the normal script for that language" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the available language matching the preferred language's script" do
            expect(matcher.match(preferred)).to eq('zh-Hant')
          end
        end

        context "and the script of the preferred language does not match the normal script for that language" do
          let(:preferred) { 'zh-Hant-CN' }

          it "returns the available language matching the preferred language's script" do
            expect(matcher.match(preferred)).to eq('zh-Hant')
          end
        end
      end

      context "and the preferred language does not match the script of an available language" do
        context "and the script of the preferred language matches the normal script for that language" do
          let(:preferred) { 'zh-Hans-CN' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end

        context "and the script of the preferred language does not match the normal script for that language" do
          let(:preferred) { 'zh-Hans-HK' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end
    end

    context "and the preferred language contains an extended language subtag" do
      context "and the preferred language also contains a language subtag" do
        context "and the extended language subtag is implied by the zh language tag" do
          let(:preferred) { 'zh-cmn' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end

        context "and the extended language subtag is not implied by the zh language tag" do
          let(:preferred) { 'zh-yue' }

          it "returns the available language matching the script implied by the extended language subtag" do
            expect(matcher.match(preferred)).to eq('zh-Hant')
          end
        end
      end

      context "and the preferred language does not contain a language subtag" do
        context "and the extended language subtag is implied by the zh language tag" do
          let(:preferred) { 'cmn' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end

        context "and the extended language subtag is not implied by the zh language tag" do
          let(:preferred) { 'yue' }

          it "returns the available language matching the script implied by the extended language subtag" do
            expect(matcher.match(preferred)).to eq('zh-Hant')
          end
        end
      end

      context "and the preferred language also contains a region subtag" do
        context "and the preferred language also contains a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'zh-cmn-HK' }

            it "returns the available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'zh-yue-HK' }

            it "returns the available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end

        context "and the preferred language does not contain a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'cmn-HK' }

            it "returns the available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'yue-HK' }

            it "returns the available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end
      end

      context "and the preferred language contains a script subtag" do
        context "and the preferred language also contains a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'zh-cmn-Hant' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'zh-yue-Hant' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end

        context "and the preferred language does not contain a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'cmn-Hant' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'yue-Hant' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end
      end

      context "and the preferred language contains both a region subtag and a script subtag" do
        context "and the preferred language also contains a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'zh-cmn-Hant-HK' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'zh-yue-Hant-HK' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end

        context "and the preferred language does not contain a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'cmn-Hant-HK' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'yue-Hant-HK' }

            it "returns the available language matching the script" do
              expect(matcher.match(preferred)).to eq('zh-Hant')
            end
          end
        end
      end
    end
  end

  context "when the available languages have both region and script subtags" do
    context "and the available languages do not contain the default language for any script" do
      let(:available) { %w{en-US zh-Hant-MO zh-Hant-HK} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-HK')
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-CN' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-Hans' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches both the region and script subtags" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-HK')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-HK' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language contains an extended language subtag" do
        context "and the preferred language also contains a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'zh-cmn' }

            it "returns nil" do
              expect(matcher.match(preferred)).to be_nil
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'zh-yue' }

            it "returns the first available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant-MO')
            end
          end
        end

        context "and the preferred language does not contain a language subtag" do
          context "and the extended language subtag is implied by the zh language tag" do
            let(:preferred) { 'cmn' }

            it "returns nil" do
              expect(matcher.match(preferred)).to be_nil
            end
          end

          context "and the extended language subtag is not implied by the zh language tag" do
            let(:preferred) { 'yue' }

            it "returns the first available language matching the script implied by the extended language subtag" do
              expect(matcher.match(preferred)).to eq('zh-Hant-MO')
            end
          end
        end

        context "and the preferred language also contains a region subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end
          end
        end

        context "and the preferred language contains a script subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-Hant-MO')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-Hant-MO')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-Hant-MO')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-Hant' }

              it "returns the first available language matching its script" do
                expect(matcher.match(preferred)).to eq('zh-Hant-MO')
              end
            end
          end
        end

        context "and the preferred language contains both a region subtag and a script subtag" do
          context "and the preferred language also contains a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'zh-cmn-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'zh-yue-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end
          end

          context "and the preferred language does not contain a language subtag" do
            context "and the extended language subtag is implied by the zh language tag" do
              let(:preferred) { 'cmn-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end

            context "and the extended language subtag is not implied by the zh language tag" do
              let(:preferred) { 'yue-Hant-HK' }

              it "returns the matching available language" do
                expect(matcher.match(preferred)).to eq('zh-Hant-HK')
              end
            end
          end
        end
      end
    end

    context "and the available languages contain the default language for the preferred language's script" do
      let(:available) { %w{en-US zh-Hant-MO zh-Hant-TW} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-MO' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the default langauge matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-TW')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-CN' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-TW')
          end
        end

        context "and the preferred language does not match an available language" do
          let(:preferred) { 'zh-Hans' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches both the region and script subtags" do
          let(:preferred) { 'zh-Hant-MO' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-TW')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-TW' }

          it "returns nil" do
            expect(matcher.match(preferred)).to be_nil
          end
        end
      end
    end

    context "and the available languages contain the default language for a script that does not match the preferred language's script" do
      let(:available) { %w{en-US zh-Hant-MO zh-Hant-HK zh-Hans-CN} }

      context "and the preferred language has only a region subtag" do
        context "and the preferred language exactly matches an available language" do
          let(:preferred) { 'zh-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-HK')
          end
        end

        context "and the preferred language has the same implied script as an available language" do
          let(:preferred) { 'zh-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end
      end

      context "and the preferred language has only a script subtag" do
        context "and the preferred language has the same script as an available language" do
          let(:preferred) { 'zh-Hant' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end
      end

      context "and the preferred language has both region and script subtags" do
        context "and the preferred language matches both the region and script subtags" do
          let(:preferred) { 'zh-Hant-HK' }

          it "returns the matching available language" do
            expect(matcher.match(preferred)).to eq('zh-Hant-HK')
          end
        end

        context "and the preferred language matches the script subtag" do
          let(:preferred) { 'zh-Hant-TW' }

          it "returns the first available language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hant-MO')
          end
        end

        context "and the preferred language matches the region subtag but not the script subtag" do
          let(:preferred) { 'zh-Hans-HK' }

          it "returns the default language matching its script" do
            expect(matcher.match(preferred)).to eq('zh-Hans-CN')
          end
        end
      end
    end
  end
end
