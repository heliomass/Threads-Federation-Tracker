## About

**Threads Federation Tracker** is a simple tool to check whether a given list of accounts on Meta's Threads has [federated](https://engineering.fb.com/2024/03/21/networking-traffic/threads-has-entered-the-fediverse/).

At the time of writing, Federation is an opt-in process for each account. This tool is a quick way to see which Threads accounts have chosen to federate, and which haven't. You can then use the results of running the script to follow those accounts which have federated on Mastodon, and if you choose you can gently prompt those unfederated users to join the Fediverse.

Please be polite when using the results of this script to encourage Threads users to federate, and respect users' decisions to decline to federate or not respond to your request.

## Usage

It's a simple bash script which reads in a CSV file listing Threads accounts, and returns a result showing which accounts have federated, and which haven't.

For example, using the following CSV file named `accounts.csv`:

```csv
heliomass
mosseri
```

Run the script:

```shell
./threads.sh --csv accounts.csv
2 accounts were processed and written to threads_accounts_20240817.csv
```

The output will be put in a new CSV file postfixed with today's date:

```csv
cat threads_accounts_20240817.csv
heliomass,FEDERATED
mosseri,FEDERATED
```

Be aware if you're editing the input CSV file in a spreadsheet application, the encoding can sometimes cause an issue with the script. The best approach is to do edit it using a text editor. The outputted CSV file may of course be safely opened in a spreadsheet application of your choice.

## How Does it Work?

The script is quite naïve in its implementation, but does the job. For each account listed in the inputted CSV file, it makes a [WebFinger](https://webfinger.net) request to Threads' [well-known URI](https://en.wikipedia.org/wiki/Well-known_URI).

If the account is federated, the request returns a `200 OK` response code. If it's not federated, it will return a `404 Not Found` response code. Any other response code is treated as an unexpected error.

## Future Development

As it stands, this v1 is really just a proof of concept. The next revision will see this rewritten in Python with a local database to track accounts. In this way it will be possible to see trends in user federation, as well as build a front-end against this database in order to present the data.
