extern crate error_chain;
extern crate glob;

use error_chain::error_chain;
use structopt::clap::AppSettings;
use structopt::StructOpt;

#[derive(StructOpt, Debug)]
#[structopt(
    about = "Create gitignore",
    settings = &[
        AppSettings::ColoredHelp,
        AppSettings::SubcommandRequiredElseHelp,
        AppSettings::UnifiedHelpMessage,
        AppSettings::VersionlessSubcommands
    ])]
enum Options {
    #[structopt(about = "Outputs the gitignore",
                settings = &[AppSettings::ColoredHelp, AppSettings::UnifiedHelpMessage])]
    Create {
        #[structopt(
            name = "TARGETS",
            help = "Specifies the tools/languages",
            required = true
        )]
        targets: Vec<String>,
    },

    #[structopt(about = "Lists the available tools and languages",
                settings = &[AppSettings::ColoredHelp, AppSettings::UnifiedHelpMessage])]
    List,
}

error_chain! {
    foreign_links {
        HttpRequest(reqwest::Error);
    }
}

const URL: &str = "https://www.gitignore.io/api/";
const LISTING_PATH: &str = "list";

#[tokio::main]
async fn main() -> Result<()> {
    let matches = Options::from_args();

    let path = match matches {
        Options::List => LISTING_PATH.to_owned(),
        Options::Create { targets } => targets.join(","),
    };
    let full_url = URL.to_owned() + &path;
    let response = reqwest::get(&full_url).await?;
    let body = response.text().await?;
    println!("{}", body);
    Ok(())
}
