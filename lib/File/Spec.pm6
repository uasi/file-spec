use v6;

module File::Spec;

use File::Spec::Unix;

INIT {
    my $osname = Q:PIR {
        $S0 = sysinfo 4
        %r = box $S0
    };

    given $osname {
        when 'MSWin32' {
            note 'File::Spec::Win32 is not implemented yet';
            !!!
        }
        default {
            our &curdir                = &File::Spec::Unix::curdir;
            our &updir                 = &File::Spec::Unix::updir;
            our &rootdir               = &File::Spec::Unix::rootdir;
            our &devnull               = &File::Spec::Unix::devnull;
            our &case_tolerant         = &File::Spec::Unix::case_tolerant;

            our &catpath               = &File::Spec::Unix::catpath;
            our &catdir                = &File::Spec::Unix::catdir;
            our &catfile               = &File::Spec::Unix::catfile;
            our &join                  = &File::Spec::Unix::join;
            our &splitpath             = &File::Spec::Unix::splitpath;
            our &splitdir              = &File::Spec::Unix::splitdir;
            our &abs2rel               = &File::Spec::Unix::abs2rel;
            our &rel2abs               = &File::Spec::Unix::rel2abs;

            our &canonpath             = &File::Spec::Unix::canonpath;
            our &file_name_is_absolute = &File::Spec::Unix::file_name_is_absolute;
            our &no_upwards            = &File::Spec::Unix::no_upwards;
            our &path                  = &File::Spec::Unix::path;
        }
    }
}

# vim: ft=perl6
