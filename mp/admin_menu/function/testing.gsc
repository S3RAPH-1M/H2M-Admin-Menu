print_test( test ) {
    self iprintln( test );
}

toggle_test( array, variable ) {
    self.toggle_test[ variable ] = !isdefined( self.toggle_test[ variable ] ) ? true : undefined;
}