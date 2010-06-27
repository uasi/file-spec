use v6;

module File::Spec::Unix;

our multi sub curdir()        { '.'         }
our multi sub updir()         { '..'        }
our multi sub rootdir()       { '/'         }
our multi sub devnull()       { '/dev/null' }
our multi sub case_tolerant() { False       }

our multi sub canonpath(Str $path is copy) {
    $path .= subst(m{ '/' ** {2..*} }    , '/', :g);
    $path .= subst(m{ '/.'+ [ '/' | $ ] }, '/', :g);
    $path .= subst(m{ ^ './'+ }          , '' , :g) unless $path eq './';
    $path .= subst(m{ ^ '/' '../'+ }     , '/', :g);
    $path .= subst(m{ ^ '/..' $ }        , '/', :g);
    $path .= subst(m{ '/' $ }            , '' , :g) unless $path eq '/';

    $path;
}

our multi sub catpath(Str $volume, Str $directory, Str $file) {
    my $path;
    if $directory ne '' &&
       $file ne '' &&
       $directory.substr(-1) ne '/' &&
       $file.substr(0, 1) ne '/' {
    $path = $directory ~ '/' ~ $file;
   }
   else {
       $path = $directory ~ $file;
   }

   $path;
}

our multi sub catdir(*@path) {
    canonpath((@path, '').join('/'));
}

our multi sub catfile(*@path is copy) {
    my $file = canonpath(@path.pop);
    return $file unless @path;

    my $dir = catdir(@path);
    $dir ~= '/' unless $dir.substr(-1) eq '/';
    
    $dir ~ $file;
}

our multi sub join(*@path) {
    catfile(@path);
}

our multi sub splitpath(Str $path, $no-file?) {
    my ($volume, $directory, $file) = ('', '', '');

    if ($no-file) {
        $directory = $path;
    }
    else {
        $path ~~ / ^ ( [ .* '/' [ \.\.? $ ]? ]? ) ( <-[/]>* ) /;
        $directory = ~$0;
        $file      = ~$1;
    }

    ($volume, $directory, $file);
}

our multi sub splitdir(Str $directory) {
    split '/', $directory;
}

our multi sub abs2rel(Str $path is copy, Str $base? is copy) {
    $base = cwd() if $base ~~ :!defined | '';

    $path = canonpath($path);
    $base = canonpath($base);

    if file_name_is_absolute($path | $base) {
        $path = rel2abs($path);
        $base = rel2abs($base);
    }
    else {
        $path = catdir('/', $path);
        $base = catdir('/', $base);
    }

    my $path_volume = splitpath($path, 1)[0];
    my $base_volume = splitpath($base, 1)[0];

    return $path unless $path_volume eq $base_volume;

    my $path_directories = splitpath($path, 1)[1];
    my $base_directories = splitpath($base, 1)[1];

    if $base_directories eq '' && file_name_is_absolute($base) {
        $base_directories = rootdir();
    }

    my @pathchunks = splitdir($path_directories);
    my @basechunks = splitdir($base_directories);

    if ($base_directories eq rootdir()) {
        shift @pathchunks;
        return canonpath(catpath('', catdir(@pathchunks), ''));
    }

    while @pathchunks && @basechunks && (@pathchunks[0] eq @basechunks[0]) {
        shift @pathchunks;
        shift @basechunks;
    }

    return curdir() unless @pathchunks || @basechunks;

    my $result_dirs = catdir(updir() xx +@basechunks, @pathchunks);

    canonpath(catpath('', $result_dirs, ''));
}

our multi sub rel2abs(Str $path is copy, Str $base? is copy) {
    if !file_name_is_absolute($path) {
        if $base ~~ :!defined | '' {
            $base = cwd();
        }
        elsif !file_name_is_absolute($base) {
            $base = rel2abs($base);
        }
        else {
            $base = canonpath($base);
        }

        $path = catdir($base, $path);
    }

    canonpath($path);
}

our multi sub file_name_is_absolute(Str $file) {
    ?($file ~~ /^'/'/);
}

our multi sub no_upwards(*@file) {
    @file.grep: { $_ ~~ none('.', '..') };
}

our multi sub path() {
    return () unless %*ENV ~~ :PATH;
    %*ENV<PATH>.split(':').map: { $_ eq '' ??  '.' !! $_ };
}

my sub cwd() {
    Q:PIR {
        $P0 = root_new ['parrot';'OS']
        push_eh cwd_catch 
        $S0 = $P0.'cwd'()
        %r = box $S0
        goto cwd_finally
      cwd_catch:
        %r = get_hll_global 'Any'
      cwd_finally:
    };
}

# vim: ft=perl6
