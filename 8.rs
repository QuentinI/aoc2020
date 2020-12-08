use std::str::FromStr;
use std::convert::TryInto;

#[derive(Debug, PartialEq)]
enum Error {
    UnknownOp(String),
    InvalidArgument(String),
    InvalidJmp(Line),
    Loop,
    EndOfProgram,
    EmptyLine,
    NoArgument,
}

#[derive(Debug, Clone, PartialEq)]
enum Op {
    Acc,
    Nop,
    Jmp
}

impl FromStr for Op {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "nop" => Ok(Self::Nop),
            "jmp" => Ok(Self::Jmp),
            "acc" => Ok(Self::Acc),
            _ => Err(Error::UnknownOp(s.to_string()))
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
struct Line {
    op: Op,
    arg: i64,
    cnt: u64
}

impl Line {
    fn from_asm<T: AsRef<str>>(asm: T) -> Result<Self, Error> {
        let mut asm = asm.as_ref().split(" ");
        let op: Op = asm.next()
                        .ok_or(Error::EmptyLine)?
                        .parse()?;
        let arg: i64 = asm.next()
                          .ok_or(Error::NoArgument)?
                          .parse().map_err(|_| Error::InvalidArgument("?".to_string()))?;
        Ok(Self {
            op: op,
            arg: arg,
            cnt: 0
        })
    }
}

struct Handheld {
    acc: i64,
    source: Vec<Line>,
    ip: usize,
}

impl Handheld {
    fn new() -> Self {
        Self {
            acc: 0,
            source: vec![],
            ip: 0
        }
    }

    fn reset(&mut self) {
        self.ip = 0;
        self.acc = 0;
        for line in self.source.iter_mut() {
            line.cnt = 0;
        }
    }

    fn load<T: AsRef<str>>(&mut self, asm: T) -> Result<(), Error> {
        self.source = asm.as_ref().trim().split("\n")
                         .map(Line::from_asm)
                         .collect::<Result<Vec<Line>, Error>>()?;
        self.reset();
        Ok(())
    }

    fn advance(&mut self) -> Result<(), Error> {
        let line = self.source.get_mut(self.ip)
                              .ok_or(Error::EndOfProgram)?;

        if line.cnt != 0 {
            return Err(Error::Loop);
        }

        self.ip += 1;

        match line.op {
            Op::Acc => self.acc += line.arg,
            Op::Nop => (),
            Op::Jmp => self.ip = (self.ip as i64 + line.arg - 1).try_into().map_err(|_| Error::InvalidJmp(line.clone()))?,
        }

        line.cnt += 1;
        Ok(())
    }

    fn execute(&mut self) -> Result<(), Error> {
        loop {
            if let Err(e) = self.advance() {
                match e {
                    Error::EndOfProgram => return Ok(()),
                    _ => return Err(e),
                }
            }
        }
    }
}

fn main() {
    let asm = include_str!("8.in");
    let mut handheld = Handheld::new();
    handheld.load(asm).expect("Invalid asm");
    assert_eq!(handheld.execute(), Err(Error::Loop));
    println!("Looped at acc {}", handheld.acc);
    for i in 0..handheld.source.len() {
        handheld.reset();

        {
            let line = handheld.source.get_mut(i).unwrap();

            if line.op == Op::Jmp {
                line.op = Op::Nop;
            } else if line.op == Op::Nop {
                line.op = Op::Jmp;
            }
        }

        if handheld.execute().is_ok() {
            println!("Terminated at acc {}", handheld.acc);
            break;
        }

        {
            let line = handheld.source.get_mut(i).unwrap();

            if line.op == Op::Jmp {
                line.op = Op::Nop;
            } else if line.op == Op::Nop {
                line.op = Op::Jmp;
            }
        }
    }
}
