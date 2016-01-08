module Native::Resources:auth<github:hoelzro>:ver<0.1.0> {
    # This needs to be in a class because of RT 127089
    my class Helper {
        method resource-lib(Str $libname, :%RESOURCES) returns Str {
            my @so-extensions = <.dll .dylib .so>;
            my @so-files = @so-extensions.map("lib/lib$libname" ~ *);

            my @non-empty-so-files = @so-files.grep: { %RESOURCES{$^filename} ~~ :!z };

            if @non-empty-so-files == 0 {
                die "Couldn't find a shared object for lib$libname";
            } elsif @non-empty-so-files > 1 {
                die "Found more than one shared object for lib$libname";
            }

            my $lib = @non-empty-so-files[0];
            %RESOURCES{$lib}.Str;
        }
    }

    our sub resource-lib(Str $libname, :%RESOURCES) returns Code is export {
        -> --> Str {
            state $lib;

            unless $lib {
                $lib = Helper.resource-lib($libname, :%RESOURCES);
            }

            $lib
        }
    }
}

