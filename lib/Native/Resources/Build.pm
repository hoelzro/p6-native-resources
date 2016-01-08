use v6;

need LibraryMake;

module Native::Resources::Build {
    our sub get-vars(|c) is export {
        LibraryMake::get-vars(|c)
    }

    our sub process-makefile(|c) is export {
        LibraryMake::process-makefile(|c)
    }

    our sub make(Str $folder, Str $destfolder, Str :$libname) is export {
        my %vars = get-vars($destfolder);
        my @fake-shared-object-extensions = <.so .dll .dylib>.grep(* ne %vars<SO>);

        %vars<FAKESO> = @fake-shared-object-extensions.map("resources/lib/lib$libname" ~ *);

        my $fake-so-rules = %vars<FAKESO>.map(-> $filename {
            qq{$filename:\n\tperl6 -e "print ''" > $filename}
        }).join("\n");

        process-makefile($folder, %vars);
        spurt("$folder/Makefile", $fake-so-rules, :append);
        shell(%vars<MAKE>);
    }
}
