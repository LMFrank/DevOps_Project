import threading

import pandas as pd
import ping3


def single_ping(ip, timeout, ping_results):
    ping_time = ping3.ping(ip, timeout=timeout)
    ping_results[ip] = ping_time
    return ping_results

def batch_ping(file='ping.xlsx', result_file='ping_result.xlsx', timeout=4):
    df = pd.read_excel(file)
    ip_items = df.to_dict(orient='records')
    ip_lists = []

    for i in ip_items:
        ip_lists.append(i['ip'])
    ping_results = {}

    threads = []
    for ip in ip_lists:
        t = threading.Thread(target=single_ping, args=(ip, timeout, ping_results))
        threads.append(t)
        t.start()
    for t in threads:
        t.join()

    for i in ip_items:
        item_ping_result = ping_results[i['ip']]
        if item_ping_result is None:
            i['result'] = '超时失败'
        elif item_ping_result is False:
            i['result'] = '域名解析失败'
        else:
            i['result'] = '成功'

    new_df = pd.DataFrame(ip_items)
    new_df.to_excel(result_file, index=False, columns=['ip', 'result'])

if __name__ == '__main__':
    batch_ping()