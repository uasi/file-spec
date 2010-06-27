use v6;
use Test;

BEGIN {
    @*INC.push: 'lib';
}

use File::Spec::Unix;

plan 67;

# These tests are stolen from PathTools-3.31/t/Spec.t

is File::Spec::Unix::case_tolerant(), '0';
 
is File::Spec::Unix::catfile('a','b','c'),   'a/b/c';
is File::Spec::Unix::catfile('a','b','./c'), 'a/b/c';
is File::Spec::Unix::catfile('./a','b','c'), 'a/b/c';
is File::Spec::Unix::catfile('c'),           'c';
is File::Spec::Unix::catfile('./c'),         'c';
 
is File::Spec::Unix::splitpath('file'),            ('', '', 'file');
is File::Spec::Unix::splitpath('/d1/d2/d3/'),      ('', '/d1/d2/d3/', '');
is File::Spec::Unix::splitpath('d1/d2/d3/'),       ('', 'd1/d2/d3/', '');
is File::Spec::Unix::splitpath('/d1/d2/d3/.'),     ('', '/d1/d2/d3/.', '');
is File::Spec::Unix::splitpath('/d1/d2/d3/..'),    ('', '/d1/d2/d3/..', '');
is File::Spec::Unix::splitpath('/d1/d2/d3/.file'), ('', '/d1/d2/d3/', '.file');
is File::Spec::Unix::splitpath('d1/d2/d3/file'),   ('', 'd1/d2/d3/', 'file');
is File::Spec::Unix::splitpath('/../../d1/'),      ('', '/../../d1/', '');
is File::Spec::Unix::splitpath('/././d1/'),        ('', '/././d1/', '');
 
is File::Spec::Unix::catpath('','','file'),            'file';
is File::Spec::Unix::catpath('','/d1/d2/d3/',''),      '/d1/d2/d3/';
is File::Spec::Unix::catpath('','d1/d2/d3/',''),       'd1/d2/d3/';
is File::Spec::Unix::catpath('','/d1/d2/d3/.',''),     '/d1/d2/d3/.';
is File::Spec::Unix::catpath('','/d1/d2/d3/..',''),    '/d1/d2/d3/..';
is File::Spec::Unix::catpath('','/d1/d2/d3/','.file'), '/d1/d2/d3/.file';
is File::Spec::Unix::catpath('','d1/d2/d3/','file'),   'd1/d2/d3/file';
is File::Spec::Unix::catpath('','/../../d1/',''),      '/../../d1/';
is File::Spec::Unix::catpath('','/././d1/',''),        '/././d1/';
is File::Spec::Unix::catpath('d1','d2/d3/',''),        'd2/d3/';
is File::Spec::Unix::catpath('d1','d2','d3/'),         'd2/d3/';
 
is File::Spec::Unix::splitdir(''),           '';
is File::Spec::Unix::splitdir('/d1/d2/d3/'), ('', 'd1', 'd2', 'd3' ,'');
is File::Spec::Unix::splitdir('d1/d2/d3/'),  ('d1', 'd2', 'd3', '');
is File::Spec::Unix::splitdir('/d1/d2/d3'),  ('', 'd1', 'd2', 'd3');
is File::Spec::Unix::splitdir('d1/d2/d3'),   ('d1', 'd2', 'd3');
 
is File::Spec::Unix::catdir(),                     '';
is File::Spec::Unix::catdir(''),                   '/';
is File::Spec::Unix::catdir('/'),                  '/';
is File::Spec::Unix::catdir('','d1','d2','d3',''), '/d1/d2/d3';
is File::Spec::Unix::catdir('d1','d2','d3',''),    'd1/d2/d3';
is File::Spec::Unix::catdir('','d1','d2','d3'),    '/d1/d2/d3';
is File::Spec::Unix::catdir('d1','d2','d3'),       'd1/d2/d3';
is File::Spec::Unix::catdir('/','d2/d3'),          '/d2/d3';
 
is File::Spec::Unix::canonpath('///../../..//./././a//b/.././c/././'), '/a/b/../c';
is File::Spec::Unix::canonpath(''),            '';
is File::Spec::Unix::canonpath('a/../../b/c'), 'a/../../b/c';
is File::Spec::Unix::canonpath('/.'),          '/';
is File::Spec::Unix::canonpath('/./'),         '/';
is File::Spec::Unix::canonpath('/a/./'),       '/a';
is File::Spec::Unix::canonpath('/a/.'),        '/a';
is File::Spec::Unix::canonpath('/../../'),     '/';
is File::Spec::Unix::canonpath('/../..'),      '/';
 
is File::Spec::Unix::abs2rel('/t1/t2/t3','/t1/t2/t3'),    '.';
is File::Spec::Unix::abs2rel('/t1/t2/t4','/t1/t2/t3'),    '../t4';
is File::Spec::Unix::abs2rel('/t1/t2','/t1/t2/t3'),       '..';
is File::Spec::Unix::abs2rel('/t1/t2/t3/t4','/t1/t2/t3'), 't4';
is File::Spec::Unix::abs2rel('/t4/t5/t6','/t1/t2/t3'),    '../../../t4/t5/t6';
is File::Spec::Unix::abs2rel('/','/t1/t2/t3'),            '../../..';
is File::Spec::Unix::abs2rel('///','/t1/t2/t3'),          '../../..';
is File::Spec::Unix::abs2rel('/.','/t1/t2/t3'),           '../../..';
is File::Spec::Unix::abs2rel('/./','/t1/t2/t3'),          '../../..';
is File::Spec::Unix::abs2rel('/t1/t2/t3', '/'),           't1/t2/t3';
is File::Spec::Unix::abs2rel('/t1/t2/t3', '/t1'),         't2/t3';
is File::Spec::Unix::abs2rel('t1/t2/t3', 't1'),           't2/t3';
is File::Spec::Unix::abs2rel('t1/t2/t3', 't4'),           '../t1/t2/t3';
 
is File::Spec::Unix::rel2abs('t4','/t1/t2/t3'),    '/t1/t2/t3/t4';
is File::Spec::Unix::rel2abs('t4/t5','/t1/t2/t3'), '/t1/t2/t3/t4/t5';
is File::Spec::Unix::rel2abs('.','/t1/t2/t3'),     '/t1/t2/t3';
is File::Spec::Unix::rel2abs('..','/t1/t2/t3'),    '/t1/t2/t3/..';
is File::Spec::Unix::rel2abs('../t4','/t1/t2/t3'), '/t1/t2/t3/../t4';
is File::Spec::Unix::rel2abs('/t1','/t1/t2/t3'),   '/t1';

