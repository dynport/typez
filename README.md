# Typez

typez is a command line tool to list aws instance types together with on-demand and minmum reserved instance prices (3 years,
high utilization).

Prices can be automatically refreshed from the AWS price list.

## Installation

    $ gem install typez 

## Usage
    $ typez --help
    Usage: typez [options]
    -r, --region REGION              AWS region to use. default: eu-west-1
    -e, --exchange-rate RATE         Rate to be used to divide prices. default: 1.0
        --refresh                    Refresh price list

    $ typez -r eu-west-1 -e 1.3217 | cut -f 1-7   # cut is only used to fit better in README.md
    region          eu-west-1
    exchange_rate   1.3217

    Type            Memory          ECU             Storage         Network         /hour   /month
    t1.micro        0.615           variable        EBS only        Very Low        0.015   11.046
    m1.small        1.7             1.0             1 x 160         Low             0.049   35.901
    m1.medium       3.75            2.0             1 x 410         Moderate        0.098   71.801
    m1.large        7.5             4.0             2 x 420         Moderate        0.197   143.603
    c1.medium       1.7             5.0             1 x 350         Moderate        0.125   91.133
    m2.xlarge       17.1            6.5             1 x 420         Moderate        0.348   254.067
    m1.xlarge       15.0            8.0             2 x 840         High            0.393   287.206
    m3.xlarge       15.0            13.0            EBS only        Moderate        0.416   303.775
    m2.2xlarge      34.2            13.0            1 x 850         Moderate        0.696   508.133
    c1.xlarge       7.0             20.0            4 x 420         High            0.499   364.531
    m3.2xlarge      30.0            26.0            EBS only        High            0.832   607.551
    m2.4xlarge      68.4            26.0            2 x 840         High            1.392   1016.267
    cg1.4xlarge     22.5            33.5            2 x 840         10 Gigabit      1.786   1303.473
    hi1.4xlarge     60.5            35.0            2 x 1,024 SSD   10 Gigabit      2.580   1883.408
    hs1.8xlarge     117.0           35.0            24 x 2,048      10 Gigabit      3.707   2706.363
    cr1.8xlarge     244.0           88.0            2 x 120 SSD     10 Gigabit      2.837   2071.196
    cc2.8xlarge     60.5            88.0            4 x 840         10 Gigabit      2.043   1491.261

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
