fn bounded_copy(dst:&mut [u8],src:&str)->usize{if dst.is_empty(){return 0;}let n=src.len().min(dst.len()-1);dst[..n].copy_from_slice(&src.as_bytes()[..n]);dst[n]=0;n}
fn main(){let mut buffer=[0u8;5];assert_eq!(bounded_copy(&mut buffer,"abcdef"),4);assert_eq!(&buffer,b"abcd\0");println!("Rust bounded_copy boundary test passed");}
